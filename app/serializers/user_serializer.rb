class UserSerializer < ActiveModel::Serializer
	ActiveModel::Serializer.config.adapter = :json
	has_many	:posts,
				:comments,
				:admin_messages
				
	attributes  :id,
				:full_name,
				:display_name,
				:email,
				:date_of_birth,
				:gender,
				:facebook_url,
				:twitter_url,
				:personal_message,
				:webpage_url,
				:is_banned,
				:is_banned_date,
				:legal_terms_read,
				:privacy_terms_read,
				:is_admin,
				:is_super_user,
				:sign_in_count,
				:current_password,
				:password,
				:last_sign_in_at,
				:created_at,
				:updated_at,
				:show_full_name,
				:posts_count,
				:admin_messages_count,
				:comments_count
end
