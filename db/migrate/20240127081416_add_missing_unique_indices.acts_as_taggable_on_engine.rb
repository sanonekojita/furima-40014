# frozen_string_literal: true

# This migration comes from acts_as_taggable_on_engine (originally 2)
class AddMissingUniqueIndices < ActiveRecord::Migration[6.0]
  def self.up
    # 外部キー制約を一時的に削除するためのコードを追加
    remove_foreign_key ActsAsTaggableOn.taggings_table, :tags if foreign_key_exists?(ActsAsTaggableOn.taggings_table, :tags)

    # ここに追加
    remove_index ActsAsTaggableOn.tags_table, :name

    add_index ActsAsTaggableOn.tags_table, :name, unique: true

    remove_index ActsAsTaggableOn.taggings_table, :tag_id if index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
    remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_taggable_context_idx'
    add_index ActsAsTaggableOn.taggings_table,
              %i[tag_id taggable_id taggable_type context tagger_id tagger_type],
              unique: true, name: 'taggings_idx'
  end

  def self.down
    # 外部キー制約を復元するためのコードを追加
    add_foreign_key ActsAsTaggableOn.taggings_table, :tags, column: :tag_id

    remove_index ActsAsTaggableOn.tags_table, :name

    remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_idx'

    add_index ActsAsTaggableOn.taggings_table, :tag_id unless index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
    add_index ActsAsTaggableOn.taggings_table, %i[taggable_id taggable_type context],
              name: 'taggings_taggable_context_idx'
  end
end
