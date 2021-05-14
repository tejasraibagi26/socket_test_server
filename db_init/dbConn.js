// const config = require("config");
const pg = require("pg-promise")();

// const pgPort = config.get("pgPort");
// const pgURL = config.get("pgURL");
// const pgDb = config.get("pgDb");
// const pgUser = config.get("pgUser");
// const pgPassword = config.get("pgPassword");

const pdb = pg({
  host: "ec2-35-174-35-242.compute-1.amazonaws.com",
  port: 5432,
  database: "d5ojseqhfgvbac",
  user: "nvsrccyoonbpam",
  password: "ded190a5f2b2017edcbd7d9c49eb269fbffb18b409b3e5321cb8d8737bbead96",
  ssl: { rejectUnauthorized: false },
});

module.exports = { pdb: pdb };
