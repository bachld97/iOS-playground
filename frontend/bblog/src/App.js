import React from 'react';
import './App.css';

import blogRootPath from './content/README.md';
import PersistentHeader from './shared/PersistentHeader';
import HomePage from './home/HomePage';

class App extends React.Component {
	render() {
		return (
			<div className="App">
				<PersistentHeader />
        <HomePage blogRootPath={blogRootPath} />
			</div>
		);
	}
}

export default App;
