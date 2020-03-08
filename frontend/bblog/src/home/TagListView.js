import React from 'react';
import './home.css'

class TagListView extends React.Component {
  componentDidMount() {
    fetch(this.props.tags)
      .then(response => response.json())
      .then(data => {
        this.setState({tagData: data})
      });
  }

  tagCellOnClick(tag) {
    window.history.pushState({ }, `BlogByTag?id=${tag}`, `/tag/${tag}/`);
  }

  render() {
    if (this.state == null) {
      return null;
    }

    const tags = this.state.tagData.tags;
    return (
      <div className="TagListContainer">
        { 
          tags.map(tag => <TagCell key={tag} tag={tag} onClick={() => this.tagCellOnClick(tag)}/>) 
        }
      </div>
    );
  }
}

class TagCell extends React.Component {
  render() {
    return (
      <div className="TagListCell Selectable" onClick={this.props.onClick}>
      <p> {this.props.tag} </p>
    </div>
    );
  }
}

export default TagListView;
