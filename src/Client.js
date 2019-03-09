exports.newClient = function (params) {
  return function () {
    return new (require('hatena-blog-api').Client)(params);
  };
};

exports.createImpl = function (params) {
  return function (client) {
    return function () {
      return client.create(params);
    };
  };
};

exports.deleteImpl = function (memberUrl) {
  return function (client) {
    return function () {
      return client.delete(memberUrl);
    };
  };
};

exports.editImpl = function (memberUrl) {
  return function (params) {
    return function (client) {
      return function () {
        return client.edit(memberUrl, params);
      };
    };
  };
};

exports.listImpl = function (client) {
  return function () {
    return client.list();
  };
};

exports.retrieveImpl = function (memberUrl) {
  return function (client) {
    return function () {
      return client.retrieve(memberUrl);
    };
  };
};
