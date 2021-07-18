import LoginFlip from './components/LoginFlip';
import SignUpE from './components/SignUpE';
import SignUp2 from './components/SignUp2';
import JobPageW from './pages/JobPageW';
import {Route, Switch} from 'react-router-dom';

function App()
{
  return (
    <div>
      <Switch>
        <Route path='/' exact>
          <LoginFlip/>
        </Route>
        <Route path='/sign-up1' exact>
          <SignUpE/>
        </Route>
        <Route path='/sign-up2' exact>
          <SignUp2/>
        </Route>
        <Route path='/jobs-w' exact>
          <JobPageW/>
        </Route>
        <Route path='/jobs-e' exact>
          <SignUpE/>
        </Route>
      </Switch>
    </div>
  );
}

export default App;
