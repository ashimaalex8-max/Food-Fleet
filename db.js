require('dotenv').config();
const mysql=require('mysql2/promise'); const {MongoClient}=require('mongodb');
const pool=mysql.createPool({host:process.env.MYSQL_HOST,user:process.env.MYSQL_USER,password:process.env.MYSQL_PASSWORD,database:process.env.MYSQL_DATABASE});
const client=new MongoClient(process.env.MONGO_URL);
module.exports={pool,client,db:()=>client.db('foodfleet')};
