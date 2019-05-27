class Restaurant < ApplicationRecord
  belongs_to :category
  belongs_to :area
  has_many :foods
  has_many :follows
  has_many :evaluations
  has_many :reviews
  has_many :restaurants, through: :follows
  after_save :reindex
  mount_uploader :picture, PictureUploader
  searchkick language: "vietnamese", merge_mappings: true,
   settings:{
       analysis: {
           analyzer:{
               vi_analyzer:{
                   type:"custom",
                   tokenizer:"standard",
                   filter: ["lowercase"]
               }
           }
       }
   },
   mappings: {
      restaurant: {
        properties: {
            name: {type: "string", analyzer: "vi_analyzer", fields: {raw:{type: "keyword"}}},
            restaurant_id: {type: "integer"},
            category_id: {type: "integer"},
            category_name: {type: "string", analyzer: "vi_analyzer", fields: {raw:{type: "keyword"}}},
            area_id: {type: "integer"},
            address: {type: "string", analyzer: "vi_analyzer", fields: {raw:{type: "keyword"}}},
            number_star: {type: "integer"},
            created_at: {type: "date"},
            food: {type: "string", analyzer: "vi_analyzer", fields: {raw:{type: "keyword"}}}
        }
      }
  }

  def search_data
    {
        restaurant_id: id,
        name: name,
        category_id: category_id,
        category_name: category.name,
        area_id: area_id,
        address: address + " " + area.district,
        number_star: number_star,
        created_at: created_at,
        food: foods.present? ? foods.map(&:name).join(" ") : ""
    }
  end

  def self.search_by(params)
    query = []
    query_keyword = {match_all: {}}
    if params[:categories].present?
      query << {terms: {"category_id" => params[:categories].map(&:to_i)}}
    end
    if params[:district].present?
      query << {terms: {"area_id" => params[:district]}}
    end
    if params[:keyword].present?
      query_keyword =  {
          multi_match:
              {
                  query: params[:keyword],
                  operator: "or",
                  analyzer: 'vi_analyzer',
                  fields: ["name^10", "food^8", "address^6", "category_name^4"]
              }
      }
    end
    restaurants = search(body: {
        query: {
            bool: {
                must: query_keyword,
                filter: query
            }
        }
    }, page: params[:page], per_page: params[:per_page] || 10)
    restaurants
  end
end