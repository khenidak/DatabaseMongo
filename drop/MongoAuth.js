var conn;
while (conn === undefined)
{
    try
    {
        conn = new Mongo("localhost:27017");
        if (conn == undefined){
          sleep(100)
        }
    }
    catch (e)
    {
        print(e);
    }

};

db = conn.getDB("admin")
db.createUser(
      {
          user: "admin",
          pwd: "complexadminpwd",
          roles: [
                 { role: "readWriteAnyDatabase", db: "admin" } ,
                ]
      }
    )

db = conn.getDB("ordering")
db.createUser(
      {
          user: "web",
          pwd: "complexpwd",
          roles: [
                 { role: "readWrite", db: "dbAdmin" } ,
                ]
      }
    )
db.grantRolesToUser(
      "web",
          [
                { role: "read", db: "ordering" },
                { role: "readWrite", db: "ordering" }
          ]
  )

// Stop the server after user creation
// db.shutdownServer()


