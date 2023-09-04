const hre = require("hardhat");

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(rersolve, ms));
}

async function main(){
  //Deploy the contract - Max number whitelisted addresses = 10
  const whitelistContract = await hre.ethers.deployContract("Whitelist",[10]);

  //Wait for the deployment
  await whitelistContract.waitForDeployment();

  //Log messsage printing address
  console.log("Whitelist Contract Address:", whitelistContract.target);

  //Sleep while Etherscan indexes teh new contract deployment
  await sleep(30 * 1000) //30 seconds

  //Verify the contract ran using etherscan
  await hre.run("verify:verify", {
    address: whitelistContract.target,
    construcorArgumentss: [10],
  });
}

//Call the main function and catch any errors
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })