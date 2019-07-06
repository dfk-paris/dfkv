class Dfkv::Record < ActiveRecord::Base
  has_many :contributions, class_name: '::Dfkv::Contribution'
  has_many :people, through: :contributions, class_name: '::Dfkv::Person'
  has_many :attributions, class_name: '::Dfkv::Attribution'
  has_many :attribs, through: :attributions, class_name: '::Dfkv::Attrib'

  belongs_to :journal, class_name: '::Dfkv::Attrib'
  belongs_to :volume, class_name: '::Dfkv::Attrib'
  belongs_to :project, class_name: '::Dfkv::Attrib'
  belongs_to :rubric, class_name: '::Dfkv::Attrib'
  belongs_to :location, class_name: '::Dfkv::Attrib'
  belongs_to :editor, class_name: '::Dfkv::Attrib'

  def self.search(terms)
    return all unless terms
    where('title LIKE :t OR citation LIKE :t', t: "%#{terms}%")
  end

  def self.by_attrib(attrib)
    return all unless attrib
    joins(:attributions).where('attribs_records.attrib_id' => attrib)
  end

  def self.by_person(role_id, person_id)
    return all unless role_id && person_id
    joins(:contributions).where('people_records.role_id' => role_id, 'people_records.person_id' => person_id)
  end

  def self.by_journal(id)
    return all unless id
    where(journal_id: id)
  end

  def self.by_volume(id)
    return all unless id
    where(volume_id: id)
  end

  def self.by_rubric(id)
    return all unless id
    where(rubric_id: id)
  end

  def self.by_location(id)
    return all unless id
    where(location_id: id)
  end

  def self.by_editor(id)
    return all unless id
    where(editor_id: id)
  end

  def self.pageit(page, per_page)
    limit(per_page).offset((page - 1) * per_page)
  end

  def people_by_role
    result = {
      'roles' => {},
      'people' => {}
    }
    contributions.includes(:person).each do |c|
      result['roles'][c.role_id] ||= c.role
      result['people'][c.role_id] ||= []
      result['people'][c.role_id] << c.person
    end
    result
  end

  def attribs_by_kind
    result = {
      'kinds' => {},
      'attribs' => {}
    }
    attribs.includes(:kind).each do |a|
      result['kinds'][a.kind_id] ||= a.kind
      result['attribs'][a.kind_id] ||= []
      result['attribs'][a.kind_id] << a
    end
    result
  end

  def human_date
    return nil unless date

    if date_human.match(/^\d{4} \d{2}$/)
      date.strftime('%B %Y')
    else
      date.strftime('%-d.%-m.%Y')
    end
  end
end