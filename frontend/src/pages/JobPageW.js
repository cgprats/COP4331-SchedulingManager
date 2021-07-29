import NavBar from '../components/NavBar';
import JobSearch from '../components/JobSearch';
import JobList from '../components/JobList';
import JobAdd from '../components/JobAdd';
import classes from './JobPageW.module.css';
import {useState} from 'react';

function JobPageW()
{
    var user = JSON.parse(localStorage.getItem('user_data'));
    const [userType, setUserType] = useState(user.Flag);
    const [jobs, setJobs] = useState([]);

    function rerender()
    {
        setJobs(JSON.parse(localStorage.getItem('jobs')));
    }

    return (
        <div className={classes.back}>
            <NavBar end='w'></NavBar>
            {userType==1 && <JobAdd></JobAdd>}
            <JobSearch utype={userType} fn={rerender}></JobSearch>
            <JobList jobs={jobs} utype={userType}></JobList>
        </div>
    );
}

export default JobPageW;