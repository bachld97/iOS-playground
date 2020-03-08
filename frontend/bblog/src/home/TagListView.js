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

  tagCellOnClick(tag) {
    window.history.pushState({ }, `BlogByTag?id=${tag}`, `/tag/${tag}/`);
  }

  cellForTagApplyingFilter(tag, tagsToFilter) {
    const isSelected = tagsToFilter.includes(tag);
    return (
      <TagCell key={tag} tag={tag} isSelected={isSelected} onClick={() => this.tagCellOnClick(tag)}/>
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
    const className = this.props.isSelected ? "TagListCellSelected" : "TagListCell Selectable";
    return (
      <div className={className} onClick={this.props.onClick}>
      <p> {this.props.tag} </p>
    </div>
    );
  }
}

export default TagListView;
