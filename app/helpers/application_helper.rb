module ApplicationHelper
  def fix_remotipart
    content = capture do
      yield
    end
    content = "#{content}" if remotipart_submitted?
    j content
  end
end
