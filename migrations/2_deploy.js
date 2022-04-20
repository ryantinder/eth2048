// migrations/2_deploy.js
const con = artifacts.require('eth2048');
// const GameItem = artifacts.require('GameItem');
module.exports = async function (deployer) { await deployer.deploy(con); }
