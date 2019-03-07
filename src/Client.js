exports.newClient = function (params) {
  return function () {
    return new (require('hatena-blog-api').Client)(params);
  };
};

exports.create = function (params) {
  return function (client) {
    return function () {
      return client.create(params);
    };
  };
};

exports.delete = function (memberUrl) {
  return function (client) {
    return function () {
      return client.delete(memberUrl);
    };
  };
};

exports.edit = function (memberUrl) {
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

exports.retrieve = function (memberUrl) {
  return function (client) {
    return function () {
      return client.retrieve(memberUrl);
    };
  };
};
