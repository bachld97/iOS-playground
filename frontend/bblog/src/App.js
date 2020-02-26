import React from 'react';
import './App.css';

import PersistentHeader from './shared/PersistentHeader'
import BlogList from './home/BlogList';
import BlogDetail from './blog/BlogDetail';

const blogListPath = '/content/blog/list.json';


const PageType  = {
  BLOG_LIST: 'Home',
  BLOG_DETAIL: 'Blog Detail',
  BLOG_BY_TAG: 'Blogs by Tag',
};

const PageRegEx = {
  BLOG_DETAIL: new RegExp('blog/[0-9]+'),
  BLOG_BY_TAG: new RegExp('tag/[a-zA-Z]+'),
};

class App extends React.Component {

  blogListPage(tagsToFilter, src) {
    const isFilter = (tagsToFilter != null);
    return (
      <div className="App">
        <PersistentHeader />
        <BlogList blogs={blogListPath} isFilter={isFilter} tagsToFilter={tagsToFilter} src={src}/>
      </div>
    )
  }

  blogDetailPage(blogId) {
    return (
      <div className="App">
        <PersistentHeader/>
        <BlogDetail 
          blogRoot={blogListPath}
          blogId={blogId}
        />
      </div>
    )
  }

  pageTypeFromState(state) {
    const url = state.url

    if (PageRegEx.BLOG_DETAIL.test(url)) {
      return PageType.BLOG_DETAIL;
    } else if (PageRegEx.BLOG_BY_TAG.test(url)) {
      return PageType.BLOG_BY_TAG;
    }

    return PageType.BLOG_LIST;
  }

  render() {
    if (this.state == null) {
      return this.blogListPage(null, 'emptyState');
    }

    const pageType = this.pageTypeFromState(this.state);

    switch (pageType) {
      case PageType.BLOG_DETAIL:
        if (this.state.data && this.state.data.blogId) {
          const blogId = this.state.data.blogId;
          return this.blogDetailPage(blogId);
        } else {
          const urlParts = this.state.url.split('/');
          const blogId = urlParts.pop() || urlParts.pop(); // Ignore trailing /
          return this.blogDetailPage(blogId);
        }
      case PageType.BLOG_LIST:
        return this.blogListPage(null, 'accessFromHome');
      case PageType.BLOG_BY_TAG:
        var tags = null;
        if (this.state.data && this.state.data.filterTag) {
          const tag = this.state.data.filterTag;
          tags = [tag]
        } else {
          const urlParts = this.state.url.split('/');
          const tag = urlParts.pop() || urlParts.pop(); // Ignore trailing /
          tags = [tag];
        }
        return this.blogListPage(tags, 'filterPostsWithTag');
      default:
        return this.blogListPage(null, 'invalidPath'); // Should be 404 page.
    }
  }

  componentDidMount() {
    let oldPushState = window.history.pushState

    window.history.pushState = (state, title, url) => {
      this.setState({url: url, data: state})
      oldPushState.call(window.history, state, title, url)
    };
    window.onpopstate = () => {
      this.setState({url: window.location.pathname})
    };

    // after initial page load use the current url to kick off the app
    this.setState({url: window.location.pathname})
  }
}

export default App;
