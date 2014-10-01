$(document).ready(function() {
  window.hitspace = false;
  function post(params) {
      method = "post"; 
      var form = document.createElement("form");
      form.setAttribute("method", method);
      form.setAttribute("action", '/move');

      for(var key in params) {
          if(params.hasOwnProperty(key)) {
              var hiddenField = document.createElement("input");
              hiddenField.setAttribute("type", "hidden");
              hiddenField.setAttribute("name", key);
              hiddenField.setAttribute("value", params[key]);
              form.appendChild(hiddenField);
           }
      }
      document.body.appendChild(form);
      form.submit();
  }
  
  $('span').on('mousedown', function () {
    window.pickedUp = event.target.id;
  })
  
  $('span').draggable({
    cursor: 'hand',
    stop: function () {
      if (window.hitspace) {
        data = {
          start: window.pickedUp,
          landing: window.hitspace
        }
        window.hitspace = false;
        post(data);
      } else {
        window.location.href = window.location.href
      }         
    }
  })
  $('.space').droppable({
    drop: function () {
      window.hitspace = this.id;
    }
  })
});