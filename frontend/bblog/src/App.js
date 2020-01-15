import React from 'react';
import './App.css';

import blogsJson from './content/blog/blog.json';
import PersistentHeader from './shared/PersistentHeader';
import HomePage from './home/HomePage';


class App extends React.Component {

	render() {
		return (
			<div className="App">
				<PersistentHeader />
        <HomePage blogsJson={blogsJson}/>
			</div>
		);
	}
}

export default App;
