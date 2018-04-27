require 'dato'
require 'dotenv'

token = ENV['DATO_API_TOKEN']

if token.blank? && File.exist?('.env')
  token = Dotenv::Environment.new('.env')['DATO_API_TOKEN']
end

if token.blank?
  raise RuntimeError, 'Missing DatoCMS site API token!'
end

printf "\033[31m!WARNING! -  this will delete all your existing DatoCMS models - press 'y' to continue: \033[0m"
prompt = STDIN.gets.chomp
raise RuntimeError, 'Action cancelled by user' unless prompt == 'y'

client = Dato::Site::Client.new(token)

####################################
## !!REMOVE ALL SITE ITEM TYPES!! ##
#####################################
client.item_types.all.each do |item_type|
  client.item_types.destroy(item_type[:id])
end

############
# HOMEPAGE #
############
#Create the model for homepage
homepage = client.item_types.create(
  name: 'Homepage',
  singleton: true,
  modular_block: false,
  sortable: false,
  tree: false,
  api_key: 'homepage',
  ordering_direction: nil,
  ordering_field: nil,
  draft_mode_active: false,
)
homepage_type_id = homepage[:id]
##FIELDS
#title
client.fields.create(
  homepage_type_id,
  api_key: 'title',
  field_type: 'string',
  appeareance: { type: 'title' },
  label: 'Title',
  localized: false,
  position: 1,
  hint: '',
  validators: { required: {} }
)
#subtitle
client.fields.create(
  homepage_type_id,
  api_key: 'subtitle',
  field_type: 'string',
  appeareance: { type: 'plain' },
  label: 'Subtitle',
  localized: false,
  position: 2,
  hint: '',
  validators: { required: {} }
)
#seo
client.fields.create(
  homepage_type_id,
  api_key: 'seo',
  label: 'SEO',
  localized: false,
  appeareance: {},
  field_type: 'seo',
  hint: '',
  position: 3,
  validators: {}
)
#Create default content for homepage
homepage_content = client.items.create(
  item_type: homepage_type_id,
  title: 'Welcome',
  subtitle: 'NeedBrainz.com website',
  seo: nil
)

##################
# MODULAR BLOCKS #
##################
##TEXT
block_text = client.item_types.create(
  name: 'Text',
  singleton: false,
  sortable: false,
  api_key: 'text',
  ordering_field: nil,
  ordering_direction: nil,
  tree: false,
  modular_block: true,
  draft_mode_active: false
)
client.fields.create(
  block_text[:id],
  api_key: 'title',
  field_type: 'string',
  appeareance: { type: 'title' },
  label: 'Title',
  localized: false,
  position: 1,
  hint: '',
  validators: {}
)
client.fields.create(
  block_text[:id],
  api_key: 'content',
  field_type: 'text',
  appeareance: { type: 'markdown' },
  label: 'Content',
  localized: false,
  position: 2,
  hint: '',
  validators: {}
)

##TEXT + IMAGE
block_text_image = client.item_types.create(
  name: 'Text + Image',
  singleton: false,
  sortable: false,
  api_key: 'text_image',
  ordering_field: nil,
  ordering_direction: nil,
  tree: false,
  modular_block: true,
  draft_mode_active: false
)
client.fields.create(
  block_text_image[:id],
  api_key: 'title',
  field_type: 'string',
  appeareance: { type: 'title' },
  label: 'Title',
  localized: false,
  position: 1,
  hint: '',
  validators: {}
)
client.fields.create(
  block_text_image[:id],
  api_key: 'content',
  field_type: 'text',
  appeareance: { type: 'markdown' },
  label: 'Content',
  localized: false,
  position: 2,
  hint: '',
  validators: {}
)
client.fields.create(
  block_text_image[:id],
  api_key: 'image',
  field_type: 'image',
  appeareance: {},
  label: 'Image',
  localized: false,
  position: 3,
  hint: '',
  validators: { required: {} }
)
client.fields.create(
  block_text_image[:id],
  api_key: 'image_position',
  field_type: 'string',
  appeareance: { type: 'plain' },
  label: 'Image Position',
  localized: false,
  position: 3,
  hint: '',
  validators: { enum: { values: ["left", "right", "top", "bottom"] } }
)

##GALLERY
block_gallery = client.item_types.create(
  name: 'Gallery',
  singleton: false,
  sortable: false,
  api_key: 'gallery',
  ordering_field: nil,
  ordering_direction: nil,
  tree: false,
  modular_block: true,
  draft_mode_active: false
)
client.fields.create(
  block_gallery[:id],
  api_key: 'images',
  field_type: 'gallery',
  appeareance: {},
  label: 'Images',
  localized: false,
  position: 1,
  hint: '',
  validators: {}
)

##FILE
block_file = client.item_types.create(
  name: 'File',
  singleton: false,
  sortable: false,
  api_key: 'file',
  ordering_field: nil,
  ordering_direction: nil,
  tree: false,
  modular_block: true,
  draft_mode_active: false
)
client.fields.create(
  block_file[:id],
  api_key: 'file',
  field_type: 'file',
  appeareance: {},
  label: 'File',
  localized: false,
  position: 1,
  hint: '',
  validators: {}
)

#################
# BLOG ARTICLES #
#################
blog_type = client.item_types.create(
  name: 'Article',
  singleton: false,
  modular_block: false,
  sortable: false,
  tree: false,
  api_key: 'article',
  ordering_direction: nil,
  ordering_field: nil,
  draft_mode_active: true
)
blog_type_id = blog_type[:id]
#article fields
blog_title = client.fields.create(
  blog_type_id,
  api_key: 'title',
  field_type: 'string',
  appeareance: { type: 'title' },
  label: 'Title',
  localized: false,
  position: 1,
  hint: '',
  validators: { required: {} }
)
published_date = client.fields.create(
  blog_type_id,
  api_key: 'published_date',
  field_type: 'date',
  appeareance: {},
  label: 'Published date',
  localized: false,
  position: 10,
  hint: '',
  validators: { required: {} },
)
client.fields.create(
  blog_type_id,
  api_key: 'slug',
  field_type: 'slug',
  appeareance: { title_field_id: blog_title[:id], url_prefix: 'https://www.needbrainz.com/blog/' },
  label: 'Slug',
  localized: false,
  position: 20,
  hint: '',
  validators: { unique: {} }
)
client.fields.create(
  blog_type_id,
  api_key: 'cover_image',
  field_type: 'image',
  appeareance: {},
  label: 'Cover Image',
  localized: false,
  position: 30,
  hint: '',
  validators: {}
)
client.fields.create(
  blog_type_id,
  api_key: 'introduction',
  field_type: 'text',
  appeareance: { type: 'markdown' },
  label: 'Introduction',
  localized: false,
  position: 35,
  hint: '',
  validators: {}
)
client.fields.create(
  blog_type_id,
  api_key: 'seo',
  field_type: 'seo',
  appeareance: {},
  label: 'SEO',
  localized: false,
  position: 40,
  hint: '',
  validators: {}
)
client.fields.create(
  blog_type_id,
  api_key: 'blocks',
  field_type: 'rich_text',
  appeareance: {},
  label: 'Blocks',
  localized: false,
  position: 50,
  hint: '',
  validators: { rich_text_blocks: { item_types: [block_text[:id], block_text_image[:id], block_gallery[:id], block_file[:id]] } },
)
#update articles default ordering
client.item_types.update(
  blog_type_id,
  name: 'Article',
  api_key: 'article',
  draft_mode_active: true,
  singleton: false,
  modular_block: false,
  sortable: false,
  tree: false,
  ordering_direction: 'desc',
  ordering_field: published_date[:id]
)
