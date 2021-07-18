import NavBar from '../components/NavBar';
import JobSearch from '../components/JobSearch';
function JobPageW()
{
    return (
        <div>
            <NavBar end='w'></NavBar>
            <JobSearch utype='w'></JobSearch>
        </div>
    );
}

export default JobPageW;