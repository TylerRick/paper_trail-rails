PaperTrail.class_eval do

  unless methods.include?(:with_metadata)
    # Adds additional metadata to versions created within the given block.  This will be merged with
    # (and may override) any metadata already set by your controller's info_for_paper_trail.
    #
    # Example:
    #   PaperTrail.with_metadata(reason: 'Update for ...')
    #
    def self.with_metadata(metadata)
      merged_metadata = (::PaperTrail.request.controller_info || {}).merge(metadata)
      PaperTrail.request(controller_info: merged_metadata) do
        yield
      end
    end
  end

  unless methods.include?(:update_metadata)
    def self.update_metadata(metadata)
      merged_metadata = (::PaperTrail.request.controller_info || {}).merge(metadata)
      PaperTrail.request.controller_info = merged_metadata
    end
  end
end
