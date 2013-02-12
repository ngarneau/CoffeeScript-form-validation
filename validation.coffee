$(document).ready ->
  ###
  RegEx
  ###
  emailRegEx = new RegExp(/^((?!\.)[a-z0-9._%+-]+(?!\.)\w)@[a-z0-9-]+\.[a-z.]{2,5}(?!\.)\w$/i)
  emptyRegEx = new RegExp(/[-_.a-zA-Z0-9]{3,}/)
  numberRegEx = new RegExp(/^[0-9]{3,}$/)
  postalCodeRegEx = new RegExp(/^[A-Z]{1}[0-9]{1}[A-Z]{1} [0-9]{1}[A-Z]{1}[0-9]{1}/) 

  ###
  Arrays of inputs, by types
  ###
  inputs = []
  emails = []
  codes = []
  selects = []
  choices = [$("#premier-choix"), $("#deuxieme-choix"), $("#troisieme-choix"), $("#quatrieme-choix")]
  numbers = []

  ###
  Fetching and sorting all form inputs
  ###
  allinputs = $(".validate").filter(":input")
  for input in allinputs
    if $(input).hasClass("text")
      inputs.push($(input))
    if $(input).hasClass("email")
      emails.push($(input))
    if $(input).hasClass("code")
      codes.push($(input))
    if $(input).hasClass("select")
      selects.push($(input))
    if $(input).hasClass("number")
      numbers.push($(input))
  
  ###
  Inputs onblur validation
  ###
  for input in inputs
    input.blur () ->
      validateInputs($(this), emptyRegEx)
  
  ###
  Email onblur validation
  ###
  for email in emails
    email.blur () ->
      validateInputs($(this), emailRegEx)

  ###
  Postal Code onblur validation
  ###
  for code in codes
    code.blur () ->
      validateInputs($(this), postalCodeRegEx)

  ###
  Selects onchange validation
  ###
  for select in selects
    select.change () ->
      validateSelect($(this))

  ###
  Numbers onblur validation
  ###
  for number in numbers
    number.blur () ->
      validateInputs($(this), numberRegEx)
  

  validateForm = () ->
    $.extend(badFields = [], validateInputs(inputs, emptyRegEx), validateInputs(emails, emailRegEx), validateInputs(codes, postalCodeRegEx), validateSelect(selects), validateInputs(numbers, numberRegEx), validateChoiceSelect(choices))
    if badFields.length is 0
      valid = true
    else
      valid = false
    return valid
  
  validateInputs = (inputs, regex) ->
    error = []
    for input in inputs
      if regex.test($(input).val())
        removeErrorStyle(input)
      else
        error.push($(input).attr("id"))
        addErrorStyle(input)
    return error

  validateSelect = (selects) ->
    error = []
    for select in selects
      if $(select).val() isnt "0"
        removeErrorStyle(select)
      else
        error.push($(select).attr("id"))
        addErrorStyle(select)
    return error
  
  validateChoiceSelect = (choices) ->
    error = []
    for choice in choices
      current = choice
      for verif in choices
        if($(current).attr("id") is $(verif).attr("id") or $(current).val() isnt $(verif).val())
        else
          error.push($(current).attr("id"))
          $("#error-choice").html(errorMessages['choices'])
    if error.length is 0
      $("#error-choice").html("")
    return error
  
  ###
  Error Styling, I changed the border of the input and put an error message within a span in the label of the same input, it's opt to you.
  ###
  addErrorStyle = (element) ->
    $(element).addClass('form-error')
    $(element).prev('label').find('.error-message').html(errorMessages[$(element).attr("id")])

  removeErrorStyle = (element) ->
    $(element).removeClass('form-error')
    $(element).prev('label').find('.error-message').html("")

  $('.validate-form').submit ->
    return validateForm()
  
    
