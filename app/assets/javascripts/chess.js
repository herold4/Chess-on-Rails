




$(document).ready(function() {
  
  function post(params) {
      method = "post"; // Set method to post by default if not specified.

      // The rest of this code assumes you are not using a library.
      // It can be made less wordy if you use one.
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
  
  
    $('span').draggable({
      stop: function () {
        if (window.hitspace) {
          data = {
            start: event.target.id,
            landing: window.hitspace
          }
        } else {
          data = {
            start: event.target.id,
            landing: 'offboard'
          }
        }
        window.hitspace = false;
        post(data);
        
      }
    })
    $('.space').droppable({
      drop: function () {
        window.hitspace = this.id;
      }
    })
});