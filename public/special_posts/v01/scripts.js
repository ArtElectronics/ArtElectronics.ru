<style>
  #m_ka {
      position: absolute;
      background-color: red;
      width: 50px;
      height: 50px;
      top: 5180px;
      z-index: 999;
      opacity: 0;
  }
</style>

<script src="/special_posts/v01/acces/js/jquery/jquery.waypoints.min.js"></script>

<script type="text/javascript">
  $(function(){
    var frame = document.getElementById("pars");
    var win = frame.contentWindow;

    $('#m_ka')
        .waypoint(function(direction) {
        win.aN_tb7();
    }, {
        //context: '#docs',
        offset: '75%'
    })
        $('#m_ka')
        .waypoint(function(direction) {
        win.aN_tb7();
    }, {
        //context: '#docs',
        offset: '-200%'
    })
  })
</script>
