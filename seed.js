const {pool,client,db}=require('../db');
(async()=>{await client.connect(); const c=await pool.getConnection();
try{
 await c.beginTransaction();
 const [r]=await c.query("SELECT COUNT(*) n FROM restaurants");
 if(r[0].n) throw Error('Seed already loaded. Recreate schema before reseeding.');
 await c.query("INSERT INTO customers(name,area) VALUES ('Asha','Central'),('Ravi','North')");
 await c.query("INSERT INTO restaurants(name,cuisine,area) VALUES ('Spice Route','Indian','Central'),('Green Bowl','Healthy','North')");
 await c.query("INSERT INTO menu_items(restaurant_id,name,price) VALUES (1,'Butter Chicken',340),(1,'Rice',120),(2,'Salad',180)");
 for(let i=0;i<30;i++){let r=i%2+1;let item=r===1?1:3;let price=r===1?340:180;
 await c.query("INSERT INTO orders(customer_id,restaurant_id,total_amount,payment_method,status,ordered_at,completed_at) VALUES (?,?,?,?, 'COMPLETED',DATE_SUB(NOW(),INTERVAL ? HOUR),DATE_SUB(NOW(),INTERVAL ? MINUTE)",[1,r,price,['UPI','Card','COD'][i%3],i+1,(i+1)*60-25]);
 const [[o]]=await c.query("SELECT LAST_INSERT_ID() id");
 await c.query("INSERT INTO order_items(order_id,item_id,quantity,unit_price) VALUES (?,?,1,?)",[o.id,item,price]);}
 await c.commit();
 await db().collection('menus').createIndex({restaurant_id:1},{unique:true});
 await db().collection('menus').createIndex({'menu_items.name':'text'});
 await db().collection('reviews').createIndex({restaurant_id:1,rating:1});
 await db().collection('menus').insertMany([{restaurant_id:1,menu_items:[{name:'Butter Chicken',price:340,tags:['ChefSpecial']},{name:'Rice',price:120,tags:[]}]},{restaurant_id:2,menu_items:[{name:'Salad',price:180,tags:['Vegetarian']}]}]);
 await db().collection('reviews').insertMany([{restaurant_id:1,rating:4.8,comment:'Fast delivery'},{restaurant_id:2,rating:4.5,comment:'Fresh food'}]);
 console.log('Demo data loaded');
}catch(e){await c.rollback();console.error(e.message)}finally{c.release();await pool.end();await client.close()}})();
