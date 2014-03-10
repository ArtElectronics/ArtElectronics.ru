// $(document).ready(function(){
//   $(".login-popup").click(function(e) {
//     e.preventDefault();
//     popupCenter(
//       $(this).attr('action'),
//       $(this).attr('data-width'),
//       $(this).attr('data-height'),
//       'authPopup'
//     );
//     e.stopPropagation();
//     return false;
//   });
// });

// function popupCenter(url, width, height, name) {
//   var left = (screen.width/2)-(width/2);
//   var top = (screen.height/2)-(height/2)-50;
  
//   return window.open(
//     url, 
//     name,
//     "menubar=no, toolbar=no, status=no, width="+width+", height="+height+", left="+left+", top="+top
//   );
// }