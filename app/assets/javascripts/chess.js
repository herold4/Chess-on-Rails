




$(document).ready(function() {
  window.hitspace = false;
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
  
  $('span').on('mousedown', function () {
    
    window.pickedUp = event.target.id;
    console.log('Picked Up:')
    console.log(window.pickedUp)  
  })
  
  $('span').draggable({
    cursor: 'hand',
    stop: function () {
      if (window.hitspace) {
        data = {
          start: window.pickedUp,
          landing: window.hitspace
        }
        console.log('move data:')
        console.log(data)
        window.hitspace = false;
        post(data);
      }         
    }
  })
  $('.space').droppable({
    drop: function () {
      window.hitspace = this.id;
      console.log('dropped to')
      console.log(this.id)
      
    }
  })
});