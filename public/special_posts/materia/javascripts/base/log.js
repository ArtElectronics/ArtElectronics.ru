if (!this.log) {
  this.log = function() {
    try {
      return console.log.apply(console, arguments);
    } catch (undefined) {}
  };
}
