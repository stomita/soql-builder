public class Field implements QueryElement {
	public String[] path { get; set; }
	public String baseObjectName { get; set; }

	public Field() {}

	public Field(String path, String baseObjectName) {
		this.path = path.split('\\.');
		this.baseObjectName = baseObjectName;
	}

	public void validate() {
		String sobjName = this.baseObjectName;
		Integer len = this.path.size();
		for (Integer i = 0; i < len; i++) {
			String refName = this.path[i];
			if (i == len - 1) {
				if (!MetadataValidator.isFieldAccessible(refName, sobjName)) {
					throw new InvalidQueryException('Field not found or not accessible: ' + refName);
				}
			} else {
				String[] parents = MetadataValidator.getParentRelationshipObjects(refName, sobjName);
				if (parents == null) {
					throw new InvalidQueryException('Relationship not foound or not accessible: ' + refName);
				} else {
					sobjName = parents[0];
				}
			}
		}
	}

	public String toSOQL() {
		return String.join(this.path, '.');
	}
}