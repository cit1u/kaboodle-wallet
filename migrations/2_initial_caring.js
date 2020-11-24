var CaringDeployer = artifacts.require("caring/CaringDeployer");

module.exports = function (deployer) {
    deployer.deploy(CaringDeployer, 1000000000000000n, true);
}