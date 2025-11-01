# frozen_string_literal: true

# Legacy routes (redirect only).
get '/videos/:topic/:playlist/episodio/:video' => redirect('/series/%{playlist}/%{video}')
get '/videos/:topic/:playlist' => redirect('/series/%{playlist}')
get '/videos/:playlist' => redirect('/series/%{playlist}')

# Legacy routes for the old topic explorer
get '/topics/:topic' => redirect('/temas/%{topic}')
get '/topics/:topic/feed' => redirect('/temas/%{topic}.atom')
get '/topics' => redirect('/temas')

# Legacy routes for topic
get '/temas/:tema' => redirect('/videos?q=%{tema}')

# Legacy routes for the text pages.
get '/terms' => redirect('/terminos')
get '/privacy' => redirect('/privacidad')
get '/disclaimer' => redirect('/responsabilidades')
get '/about/dnt' => redirect('/dnt')
