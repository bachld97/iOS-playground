import React from 'react';
import './home.css'

class TagListView extends React.Component {
  componentDidMount() {
    this.mounted = true;
    fetch(this.props.tags)
      .then(response => response.json())
      .then(data => {
        if (this.mounted) {
          this.setState({tagData: data});
        }
      });
  }

  componentWillUnmount() {
    this.mounted = false;
  }

  tagCellOnClick(tag, currentFilter) {
    var newFilter = null;
    if (currentFilter == null) {
      newFilter = tag;
    } else if (currentFilter.includes(tag)) {
      newFilter = currentFilter.filter(value => value !== tag).join('&');
    } else {
      currentFilter.push(tag);
      newFilter = currentFilter.join('&');
    }

    window.history.pushState({ }, `BlogByTag?tags=${newFilter}`, `/tag/${newFilter}/`);
  }

  cellForTagApplyingFilter(tag, tagsToFilter) {
    const isSelected = tagsToFilter != null && tagsToFilter.includes(tag);
    return (
      <TagCell 
        key={tag} tag={tag} isSelected={isSelected} 
        onClick={() => this.tagCellOnClick(tag, tagsToFilter)}
      />
    );
  }

  render() {
    if (this.state == null) {
      return null;
    }

    const tags = this.state.tagData.tags;
    return (
      <div className="TagListContainer">
        { tags.map(tag => this.cellForTagApplyingFilter(tag, this.props.tagsToFilter)) }
      </div>
    );
  }
}

class TagCell extends React.Component {
  render() {
    const className = this.props.isSelected ? "TagListCellSelected Selectable" : "TagListCell Selectable";
    const onClick = this.props.onClick;
    return (
      <div className={className} onClick={onClick}>
        <p> {this.props.tag} </p>
      </div>
    );
  }
}

export default TagListView;
