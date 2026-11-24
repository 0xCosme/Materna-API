const { randomInt } = require("node:crypto");

const generateOtp = function () {
    return randomInt(100000, 1000000);
};

module.exports = {
    generateOtp
};
