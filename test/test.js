const con = artifacts.require("eth2048");
contract("eth2048", (accounts) => {
  it("test", async () => {
    const instance = await con.deployed();
    var rec = await instance.createGame();
    // for (let i = 0; i < 20; i++) {
    //   const rand = Math.round(Math.random() * 3) + 1;
    //   console.log(rand)
    //   var rec = await instance.move(rand);
    // }
    // var rec = await instance.move(1);

    console.log(rec.logs.accounts["1"])
  });
});
