const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract =  await domainContractFactory.deploy("king");
    await domainContract.deployed();

    console.log("Contract deployed to: ", domainContract.address);

        let txn = await domainContract.register("cavalier", {value: hre.ethers.utils.parseEther('0.1')});
        await txn.wait();
        console.log("Minted domain cavalier.king")

    txn = await domainContract.setRecord("cavalier", "I am a cavalier or a king?");
    await txn.wait();
    console.log("set record for cavalier.king");

    const address = await domainContract.getAddress("cavalier");
    console.log("owner of the domain cavalier is:", address);

    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("contract balance:", hre.ethers.utils.formatEther(balance));
};

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    } catch (error){
        console.log(error);
        process.exit(1);
    }
};

runMain();