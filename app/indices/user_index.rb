ThinkingSphinx::Index.define :user, with: :active_record do
  #fields
  indexes screen_name, sortable: true
  indexes email, as: :email
end