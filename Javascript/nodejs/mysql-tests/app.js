/*
* Filename: app.js
* 
* Author: Julio Cesar Torres <julio.torres@gmail.com> (@juliozohar)
* Date: 2016-06-01
*
*   Copyright 2021 Kryptogarten LLC
*
*   Licensed under the Apache License, Version 2.0 (the "License");
*   you may not use this file except in compliance with the License.
*   You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
*   Unless required by applicable law or agreed to in writing, software
*   distributed under the License is distributed on an "AS IS" BASIS,
*   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*   See the License for the specific language governing permissions and
*   limitations under the License.
*/
const mysql = require('mysql'); 

const con = mysql.createConnection({
    host: 'localhost',
    user: 'zohar',
    password: '103594',
    database: 'sitepoint'
}); 

con.connect((err) => {
    if (err) throw err; 
    console.log("Connected");
});

con.query('SELECT * FROM authors', (err, rows) =>{
    if(err) throw (err); 

    console.log(`Data received from DB:`);
    console.log(rows);

    rows.forEach(row => {
        console.log(`${row.name} lives in ${row.city}`); 
    });
});

con.query('UPDATE authors SET city=? where ID= ?', ['Leipzig', 3], (err, result) => {
    if(err) throw(err); 

    console.log(`Changed ${result.changedRows} rows())`);
});

con.query('DELETE FROM authors WHERE id=?', [9], (err, result) => {
    if(err) throw (err); 
    console.log(`Deleted ${result.affectedRows} row(s)`);
});

const author = {
    name: 'Craig Buckler', 
    city: 'Exmouth'
};
con.query('INSERT INTO authors SET ?', author, (err, res) => {
    if(err) throw(err); 
    console.log('Last insert ID: ', res.insertId);
});

con.query('CALL sp_get_authors()', function(err, rows){
    if(err) throws(err); 

    console.log('Data received from DB stored procedure: '); 
    console.log(rows); 
});

con.end((err) => {
    console.log("Gracefully finishing");
});