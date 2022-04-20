const con = artifacts.require("eth2048");
contract("eth2048", (accounts) => {
  it("test", async () => {
    const instance = await con.deployed();
    const balance = await instance.state();
    console.log(balance.logs);
    assert.equal(balance, 10000);
  });
});
