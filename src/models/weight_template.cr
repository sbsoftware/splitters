require "./application_record"
require "./group"
require "./group_membership"
require "./weight_template_membership"

class WeightTemplate < ApplicationRecord
  DEFAULT_NAME = "Standard"

  column group_id : Int64
  column name : String
  column created_at : Time
  column updated_at : Time

  has_many_of WeightTemplateMembership

  def group
    Group.find(group_id)
  end

  def default_template? : Bool
    group.default_weight_template.try(&.id) == id
  end

  def self.create(**args : **T) : self forall T
    transaction do
      args_with_timestamps =
        {% if @type.instance_vars.any? { |v| v.name == "created_at".id && v.annotation(Column) } &&
              @type.instance_vars.any? { |v| v.name == "updated_at".id && v.annotation(Column) } %}
          args.merge(
            created_at: args[:created_at]? || Time.utc,
            updated_at: args[:updated_at]? || Time.utc
          )
        {% elsif @type.instance_vars.any? { |v| v.name == "created_at".id && v.annotation(Column) } %}
          args.merge(created_at: args[:created_at]? || Time.utc)
        {% elsif @type.instance_vars.any? { |v| v.name == "updated_at".id && v.annotation(Column) } %}
          args.merge(updated_at: args[:updated_at]? || Time.utc)
        {% else %}
          args
        {% end %}

      record_id = insert_record(**args_with_timestamps)
      args_with_id = args_with_timestamps.merge(id: record_id)
      template = new(**args_with_id)
      group_id_value = template.group_id.value

      GroupMembership.where(group_id: group_id_value).each do |membership|
        next if WeightTemplateMembership.where(weight_template_id: template.id, group_membership_id: membership.id).first?

        WeightTemplateMembership.create(
          weight_template_id: template.id,
          group_membership_id: membership.id,
          weight: membership.weight.value
        )
      end

      template
    end.not_nil!
  end
end
