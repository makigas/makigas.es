# frozen_string_literal: true

# Legacy routes (redirect only).
get '/videos/:topic/:playlist/episodio/:video' => redirect('/series/%{playlist}/%{video}')
get '/videos/:topic/:playlist' => redirect('/series/%{playlist}')
get '/videos/:playlist' => redirect('/series/%{playlist}')

# Legacy routes for the old topic explorer. Topics are now tags.
get '/topics/:topic' => redirect('/explorar/tema/%{topic}')
get '/topics/:topic/feed' => redirect('/explorar/tema/%{topic}')
get '/topics' => redirect('/temas')

# Legacy route for the old topic URL shape
get '/temas/:tema' => redirect('/explorar/tema/%{tema}')

# Legacy routes for the text pages.
get '/terms' => redirect('/terminos')
get '/privacy' => redirect('/privacidad')
get '/disclaimer' => redirect('/responsabilidades')
get '/about/dnt' => redirect('/dnt')
