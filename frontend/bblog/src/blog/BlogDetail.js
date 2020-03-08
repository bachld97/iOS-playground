import React from 'react';
import MarkdownView from '../shared/markdownview/MarkdownView'

export default class BlogDetail extends React.Component {
  componentDidMount() {
    const blogId = this.props.blogId;
    fetch(this.props.blogRoot)
      .then(response => response.json())
      .then(data => data.details[`${blogId}`])
      .then(detailData => {
        if (detailData && detailData.path) {
          this.fetchContentFromPath(detailData.path)
        }
      });
  }

  fetchContentFromPath(path) {
    fetch(path)
      .then(response => response.text())
      .then(text => this.setState({ content: text })
      );
  }

  render() {
    if (this.state == null || this.state.content == null) {
      return null;
    }
    return <MarkdownView content={this.state.content}/>;
  }
}
