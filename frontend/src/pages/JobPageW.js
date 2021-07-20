import NavBar from '../components/NavBar';
import JobSearch from '../components/JobSearch';
import JobList from '../components/JobList';

const DUMMY_DATA = [
    {
        id: 1,
        title: 'This is an example title',
        address: '4000 Central Florida Blvd, Orlando, FL, 32816',
        start: '7/18/2021',
        end: '7/21/2021',
        client: 'Bobby Dylan',
        email: 'BobDill@gmail.com',
        phone: '305-519-8560',
        maxWorkers: '4',
        workers: [

        ],
        briefing: 'This is a very short example briefing with no formatting',
    },
    {
        id: 2,
        title: 'This is a second example title',
        address: '9000 SW 196 Dr',
        start: '7/25/2021',
        end: '8/2/2021',
        client: 'Biggie Smalls',
        email: 'biggieDaGoat@hotmail.com',
        phone: '305-804-0523',
        maxWorkers: '6',
        workers: [
            {
                email:'seanmbmiami@gmail.com',
                name: 'Sean Bennett',
                phone: '305-519-8560'
            },
            {
                email:'kmbmiami@gmail.com',
                name: 'Trish Nigrelli',
                phone: '786-367-6792'
            }
        ],
        briefing: 'This is a longer briefing. It has formatting in the form of this list. Definitely going to need word wrap to make this look nice, because ho boy just look how long its getting',
    }
];
function JobPageW()
{
    return (
        <div>
            <NavBar end='w'></NavBar>
            <JobSearch utype='w'></JobSearch>
            <JobList jobs={DUMMY_DATA} utype='w'></JobList>
        </div>
    );
}

export default JobPageW;