import React from 'react';
import MarkdownView from '../shared/markdownview/MarkdownView';


class HomePage extends React.Component {
  render() {
    const blogs = this.props.blogsJson.data
    return (
      <div className="HomeContent">
        { blogs.map(oneBlog => <MarkdownView content={oneBlog.content}/>) }
      </div>
    );
  }
}

export default HomePage;
