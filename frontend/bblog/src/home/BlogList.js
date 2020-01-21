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
      id in blogs['titleById'] &&
      id in blogs['descriptionById'] &&
      id in blogs['detailPathById']
    )
  }

  blogCellOnClick(blogId) {
    console.log(blogId)
  }

  render() {
    if (this.state == null) {
      return null;
    }
    const blogs = this.state.blogs
    const blogIds = blogs['id']
    return (
      <div>
        { blogIds
            .filter(id => this.blogNotNull(blogs, id))
            .map(id => 
              <BlogCell 
                key={id}
                id={id} 
                title={blogs['titleById'][id]}
                description={blogs['descriptionById'][id]}
                detailPath={blogs['detailPathById'][id]}
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
