var Caring 
var CaringDeployer = artifacts.require("CaringDeployer");

module.exports = function (deployer) {
    deployer.deploy(CaringDeployer);
}