import React from 'react';
import './home.css'

class BlogList extends React.Component {

  componentDidMount() {
    fetch(this.props.blogs)
      .then(response => response.json())
      .then(data => {
        this.setState({blogs: data})
      });
  }

  blogNotNull(blogs, id) {
    return (
      id in blogs.details &&
      blogs.details[id].title &&
      blogs.details[id].description &&
      blogs.details[id].path
    )
  }

  blogCanShow(blogs, id, isFilter, tagsToFilter) {
    if (!isFilter) {
      return true;
    }

    const tagsOfPost = blogs.details[id].tags;
    if (tagsOfPost == null) {
      console.log('Meh');
      return false;
    }

    var postIsIncluded = false;
    for (let postTag of tagsOfPost) {
      for (let filterTag of tagsToFilter) {
        if (postTag.toLowerCase() === filterTag.toLowerCase()) {
          postIsIncluded = true;
        }
      }
    }
    return postIsIncluded;
  }

  blogCellOnClick(blogId) {
    window.history.pushState({ blogId }, 'Hello World', `/blog/${blogId}/`);
  }

  render() {
    if (this.state == null) {
      return null;
    }
    const blogs = this.state.blogs
    const isFilter = this.props.isFilter
    const tagsToFilter = this.props.tagsToFilter
    const blogIds = blogs['id']

    return (
      <div>
        { blogIds
            .filter(id => this.blogNotNull(blogs, id))
            .filter(id => this.blogCanShow(blogs, id, isFilter, tagsToFilter))
            .map(id => 
              <BlogCell 
                key={id}
                id={id} 
                title={blogs.details[id].title}
                description={blogs.details[id].description}
                detailPath={blogs.details[id].path}
                onClick={() => this.blogCellOnClick(id)}
              />
            )
        }
      </div>
    )
  }
}

class BlogCell extends React.Component {
  render() {
    return (
      <div className='BlogCell' onClick={this.props.onClick}>
        <h1> { this.props.title } </h1>
        <p> { this.props.description } </p>
      </div>
    )
  }
}

export default BlogList;
