module FlickrHelper
	def user_photos(user_id, photo_count = 60)
		flickr = FlickRaw::Flickr.new
		total_photos = flickr.photos.search(:user_id => user_id).count
		flickr.photos.search(:user_id => user_id).first(photo_count)
	end

	def get_id_from_username(username)
		begin
			flickr = FlickRaw::Flickr.new
			flickr.people.findByUsername(:username => username)
		rescue Exception
			render :partial => 'flickr/unavailable'
		end
	end

	def render_flickr_photos(user_id, photo_count = 60, columns = 6)
		begin
			unless user_id =~ /\A\d+@N\d\d\z/
				puts "searching for user_id"
				user_id = get_id_from_username(user_id)["nsid"]
			end
			photos = user_photos(user_id, photo_count)
			photos = photos.in_groups_of(6)
			render :partial => '/flickr/photos', :locals => { :photos => photos, :user_id => user_id }
		rescue Exception
			render :partial => 'flickr/unavailable'
		end
	end
end
