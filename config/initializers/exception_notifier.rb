Openmeetup::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[OpenMeetup] ",
    :sender_address => %{"noreply@openmeetup.net" <noreply@openmeetup.net>},
    :exception_recipients => %w{bence.nagy@gmail.com}
