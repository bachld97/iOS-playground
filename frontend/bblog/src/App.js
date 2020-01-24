import React from 'react';
import './App.css';

import PersistentHeader from './shared/PersistentHeader'
import BlogList from './home/BlogList';
import BlogDetail from './blog/BlogDetail';

const blogListPath = 'content/blog/list.json';


const PageType  = {
    BLOG_LIST: 'Home',
    BLOG_DETAIL: 'Blog Detail',
};

const PageRegEx = {
    BLOG_DETAIL: new RegExp('blog/[0-9]+'),
};

class App extends React.Component {

    blogListPage = (
        <div className="App">
            <PersistentHeader />
            <BlogList blogs={blogListPath}/>
        </div>
    );

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

        console.log(url);

        if (PageRegEx.BLOG_DETAIL.test(url)) {
            return PageType.BLOG_DETAIL;
        }

        return PageType.BLOG_LIST;
    }

    render() {
        if (this.state == null) {
            return this.blogListPage;
        }

        const pageType = this.pageTypeFromState(this.state);

        switch (pageType) {
            case PageType.BLOG_DETAIL:
                if (this.state.date && this.state.data.blogId) {
                    const blogId = this.state.data.blogId;
                    return this.blogDetailPage(blogId);
                } else {
                    const urlParts = this.state.url.split('/');
                    const blogId = urlParts.pop() || urlParts.pop(); // Ignore trailing /
                    return this.blogDetailPage(blogId);
                }
            case PageType.BLOG_LIST:
                return this.blogListPage;
            default:
                return this.blogListPage; // Should be 404 page.
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
