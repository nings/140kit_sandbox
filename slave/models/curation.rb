class Curation
  
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :index => [:curation_researcher_id]
  property :single_dataset, Boolean, :index => [:researcher_id_single_dataset], :default => true
  property :analyzed, Boolean, :index => [:researcher_id_analyzed], :default => false
  property :created_at, Time, :default => Time.now
  property :updated_at, Time, :default => Time.now
  property :archived, ParanoidBoolean, :default => false
  property :researcher_id, Integer, :index => [:curation_researcher_id, :researcher_id, :researcher_id_analyzed, :researcher_id_single_dataset]
  belongs_to :researcher, :child_key => :researcher_id
  has n, :datasets, :through => Resource
  has n, :analysis_metadatas
  has n, :tweets, :through => :datasets
  has n, :users, :through => :datasets
  
  def stored_folder_name
    return name.downcase.gsub(/[\ |\=|\-|\(|\)|\*|\&|\^|\%|\$|\#|\@|\!]/, "_")+"_"+id.to_s+"_"+researcher_id.to_s
  end
  
  def tweets_count
    return datasets.collect{|d| d.tweets_count}.sum
  end
  
  def users_count
    return datasets.collect{|d| d.users_count}.sum
  end
  
end