class ContactsController < ApplicationController

# GET request to /contact_us
# Show new contact form
def new
  @contact = Contact.new
end

# POST request /contacts 
def create
  # Mass assignment of form fields into Contact object
  @contact = Contact.new(contact_params)
  # Save the Contact object to the database
  if @contact.save
  # Store form fields via paramaters, into variables
    name = params[:contact][:name]
    email = params[:contact][:email]
    comments = params[:contact][:comments]
    # Plug variables into Contact Mailer
    # email method and send email
    ContactMailer.contact_email(name, email, comments).deliver
    # Store success messain the flash hash
    # and redirect to the new action
      flash[:success] = "Message sent."
     redirect_to contact_us_path
  else
    # If Contact object doesnt save
    # store errors in the flash has
    # and redirect to the new action
    flash[:danger] = @contact.errors.full_messages.join(", ")
     redirect_to contact_us_path
  end
end
# To collect data from form, we need to yse
# strong parameters and whitelist the form fields
private
  def contact_params
     params.require(:contact).permit(:name, :email, :comments)
  end
end