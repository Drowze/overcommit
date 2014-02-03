module Overcommit::Hook::PreCommit
  # Checks for invalid whitespace (hard tabs or trailing whitespace) in files.
  class Whitespace < Base
    def run
      paths = applicable_files.join(' ')

      # Catches hard tabs
      result = command("grep -Inl \"\\t\" #{paths}")
      unless result.stdout.empty?
        return :bad, "Don't use hard tabs:\n#{result.stdout}"
      end

      # Catches trailing whitespace, conflict markers etc
      result = command('git diff --check --cached')
      return :bad, result.stdout unless result.success?

      :good
    end
  end
end