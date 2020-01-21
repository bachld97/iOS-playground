import React from 'react';
import './App.css';

import PersistentHeader from './shared/PersistentHeader'
import BlogList from './home/BlogList';

const blogListPath = 'content/blog/list.json'

class App extends React.Component {

	render() {
		return (
			<div className="App">
				<PersistentHeader />
        <BlogList blogs={blogListPath}/>
			</div>
		);
	}
}

export default App;
