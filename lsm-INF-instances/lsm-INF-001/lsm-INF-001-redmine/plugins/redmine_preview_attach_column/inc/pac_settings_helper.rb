#require 'pac_constants'

#module SettingsHelper

  def pac_fill_tooltips_dropdown(default_value)

    names = []

    cf=CustomField.find_by_name(PreviewAttachColumn::USER_CF_ISSUE_TOOLTIP_MODE)
    if cf
      cf.possible_values.each do |v|
        if v=~ /^\[([0-9]+)\]\s+(.*)$/
          names << [$2, ($1.to_i-1).to_s] if $1.to_i != 0
        end
      end
    end
    if names.size == 0
      3.times do |i|
        names << [l("label_pac_settings_issue_tips_mode_#{i.to_s}"),i.to_s]
      end
    end

    return options_for_select(names, default_value)
  end

#end
